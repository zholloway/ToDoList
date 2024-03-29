App = {
    loading: false,
    contracts: {},

    load: async () => {
        await App.loadWeb3();
        await App.loadAccount()
        await App.loadContract()
        await App.render()
    },

    // https://medium.com/metamask/https-medium-com-metamask-breaking-change-injecting-web3-7722797916a8
    loadWeb3: async() => {
        if (typeof web3 !== 'undefined') {
            App.web3Provider = web3.currentProvider
            web3 = new Web3(web3.currentProvider)
          } else {
            window.alert("Please connect to Metamask.")
          }
          // Modern dapp browsers...
          if (window.ethereum) {
            window.web3 = new Web3(ethereum)
            try {
              // Request account access if needed
              await ethereum.enable()
              // Acccounts now exposed
              web3.eth.sendTransaction({/* ... */})
            } catch (error) {
              // User denied account access...
            }
          }
          // Legacy dapp browsers...
          else if (window.web3) {
            App.web3Provider = web3.currentProvider
            window.web3 = new Web3(web3.currentProvider)
            // Acccounts always exposed
            web3.eth.sendTransaction({/* ... */})
          }
          // Non-dapp browsers...
          else {
            console.log('Non-Ethereum browser detected. You should consider trying MetaMask!')
          }
    },

    loadAccount: async() => {
        // Set the current blockchain account
        App.account = web3.eth.accounts[0]
    },

    loadContract: async() => {
        // Create a JavaScript version of the smart contract
        const toDoList = await $.getJSON('ToDoList.json')
        App.contracts.toDoList = TruffleContract(toDoList)
        App.contracts.toDoList.setProvider(App.web3Provider)

        // Hydrate the smart contract with values from the blockchain
        App.toDoList = await App.contracts.toDoList.deployed()
    },

    setLoading: (boolean) => {
        App.loading = boolean
        const loader = $('#loader')
        const content = $('#content')
        if (boolean) {
          loader.show()
          content.hide()
        } else {
          loader.hide()
          content.show()
        }
    },

    render: async () => {
        // Prevent double render
        if (App.loading) {
          return
        }
    
        // Update app loading state
        App.setLoading(true)
    
        // Render Account
        $('#account').html(App.account)
    
        // Render Tasks
        await App.renderTasks()
    
        // Update loading state
        App.setLoading(false)
    },

    renderTasks: async() => {
        const taskCount = await App.toDoList.getTaskCount()
        const $taskTemplate = $('.taskTemplate')

        for (var i = 0; i <= taskCount; i++)
        {
            let task = await App.toDoList.getTask(i)
            let taskId = task[0].toNumber()
            let taskContent = task[1]
            let taskCompleted = task[2]

            let $newTaskTemplate = $taskTemplate.clone()

            $newTaskTemplate.find('.taskContent')
                            .html(taskContent)

            $newTaskTemplate.find('input')
                            .prop('name', taskId)
                            .prop('checked', taskCompleted)
                            //.on('click', App.toggleCompleted)

            $newTaskTemplate.show()
        }
    }
}

$(() => {
    $(window).load(() => {
        App.load()
    })
})