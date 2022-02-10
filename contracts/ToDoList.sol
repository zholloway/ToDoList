// SPDX-License-Identifier: MIT
pragma solidity >0.5.0;
import { TaskLibrary } from "../libs/TaskLibrary.sol";
import { Task } from "../structs/Task.sol";
import { TaskEventLibrary } from "../libs/TaskEventLibrary.sol";

contract ToDoLists
{
    address owner;
    uint256 private taskCount = 0;
    mapping(uint256 => Task) tasks;

    modifier ownerOnly()
    { 
        require(owner == msg.sender);
        _;
    }

    constructor()
    {
        owner = msg.sender;
    }

    function createTask(
        string memory _content
    )
    public 
    ownerOnly
    {
        uint256 _taskId = taskCount + 1;
        Task memory _task = Task({
                id: _taskId,
                content: _content,
                completed: false
            });
        tasks[_taskId] = _task;
        taskCount++;
        TaskEventLibrary.EmitTaskCreated(_task);
    }

    function markTaskCompleted(
        uint256 _taskId
    )
    public 
    ownerOnly
    {
        Task memory _task = tasks[_taskId];
        _task.completed = true;
        tasks[_taskId] = _task;
        TaskEventLibrary.EmitTaskCompleted(_task);
    }

    function deleteTask(
        uint256 _taskId
    )
    public 
    ownerOnly
    {
        require(taskCount > 0);
        delete tasks[_taskId];
        taskCount--;
    }
}