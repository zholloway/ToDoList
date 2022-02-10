// SPDX-License-Identifier: MIT
pragma solidity > 0.5.0;
import { Task, ProgressStatus } from "../structs/Task.sol";
import { TaskEvents } from "../libs/TaskEventLibrary.sol";

contract ToDoLists
{
    using TaskEvents for Task;

    address owner;
    uint256 taskCount = 0;
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
                progressStatus: ProgressStatus.New,
                isActive: true
            });
        tasks[_taskId] = _task;
        taskCount++;
        _task.EmitCreated();
    }

    function updateProgressStatus(
        uint256 _taskId,
        uint256 _progressStatus
    )
    public 
    ownerOnly
    {
        require(_progressStatus < 3);
        Task memory _task = tasks[_taskId];
        ProgressStatus _newStatus = ProgressStatus(_progressStatus);
        require(_task.progressStatus != _newStatus);
        _task.progressStatus = _newStatus;
        tasks[_taskId] = _task;
        _task.EmitProgressStatusUpdate();
    }

    function deleteTask(
        uint256 _taskId
    )
    public 
    ownerOnly
    {
        Task memory _task = tasks[_taskId];
        _task.isActive = false;
        tasks[_taskId] = _task;
        _task.EmitDeleted();
    }
}