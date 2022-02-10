const Migrations = artifacts.require("Migrations");
const ToDoList = artifacts.require("ToDoList");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(ToDoList);
};
