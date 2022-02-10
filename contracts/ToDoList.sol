// SPDX-License-Identifier: MIT
pragma solidity > 0.5.0;

contract ToDoList
{
    address payable private owner;
    uint256 private taskCount = 0;
    mapping(uint256 => Task) private tasks;

    modifier ownerOnly()
    { 
        require(owner == msg.sender);
        _;
    }

    enum ProgressStatus {
        New,
        InProgress,
        Complete
    }

    struct Task {
        uint256 id;
        string content;
        ProgressStatus progressStatus;
        bool isActive;
    }

    event TaskCreated(uint256 taskId, string content);
    event TaskProgressStatusUpdate (uint256 taskId, ProgressStatus progressStatus);
    event TaskDeleted(uint256 _taskId);

    constructor()
    {
        owner = payable(msg.sender);
    }

    function getTaskCount() public view ownerOnly returns (uint256)
    {
        return taskCount;
    }

    function getTask(uint256 taskId) public view ownerOnly returns (Task memory)
    {
        return tasks[taskId];
    }

    function createTask(string memory _content) public ownerOnly
    {
        uint256 taskId = taskCount + 1;

        Task memory task = Task({
            id: taskId,
            content: _content,
            progressStatus: ProgressStatus.New,
            isActive: true
        });

        tasks[taskId] = task;
        taskCount++;

        emit TaskCreated(taskId, _content);
    }

    function updateProgressStatus(uint256 taskId, uint256 progressStatus) public ownerOnly
    {
        requireTaskExists(taskId);
        require(progressStatus < 3, "Progress status does not exist");

        Task memory task = tasks[taskId];
        ProgressStatus newStatus = ProgressStatus(progressStatus);

        require(task.progressStatus != newStatus, "Task is already set to given progress status");

        task.progressStatus = newStatus;
        tasks[taskId] = task;

        emit TaskProgressStatusUpdate(task.id, newStatus);
    }

    function requireTaskExists(uint256 taskId) private view 
    {
        require (taskId <= taskCount, "Task does not exist");
    }

    function deleteTask(uint256 taskId) public ownerOnly
    {
        requireTaskExists(taskId);

        Task memory task = tasks[taskId];

        task.isActive = false;
        tasks[taskId] = task;

        emit TaskDeleted(taskId);
    }
}