// SPDX-License-Identifier: MIT
pragma solidity > 0.5.0;
import { Task } from "../structs/Task.sol";
import { TaskEvents } from "../libs/TaskEvents.sol";
import { ProgressStatus } from "../enums/ProgressStatus.sol";

contract ToDoList
{
    using TaskEvents for Task;

    address payable private owner;
    uint256 private taskCount = 0;
    mapping(uint256 => Task) private tasks;

    modifier ownerOnly()
    { 
        require(owner == msg.sender);
        _;
    }

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
        task.EmitCreated();
    }

    function updateProgressStatus(uint256 taskId, uint256 progressStatus) public ownerOnly
    {
        require(progressStatus < 3, "Progress status does not exist");
        Task memory _task = tasks[taskId];
        ProgressStatus _newStatus = ProgressStatus(progressStatus);
        require(_task.progressStatus != _newStatus, "Task is already set to given progress status");
        _task.progressStatus = _newStatus;
        tasks[taskId] = _task;
        _task.EmitProgressStatusUpdate();
    }

    function deleteTask(uint256 _taskId) public ownerOnly
    {
        Task memory _task = tasks[_taskId];
        _task.isActive = false;
        tasks[_taskId] = _task;
        _task.EmitDeleted();
    }
}