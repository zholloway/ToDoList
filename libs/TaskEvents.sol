pragma solidity > 0.5.0;

import { Task } from "../structs/Task.sol";
import { ProgressStatus } from "../enums/ProgressStatus.sol";

library TaskEvents
{
    event TaskCreated(uint256 taskId, string content);

    event TaskProgressStatusUpdate (uint256 taskId, ProgressStatus progressStatus);

    event TaskDeleted(uint256 _taskId);

    function EmitCreated(Task memory task) internal
    {
        require(task.isActive && task.progressStatus == ProgressStatus.New, "Task is not valid Create event");
        emit TaskCreated(task.id, task.content);
    }

    function EmitProgressStatusUpdate(Task memory task) internal
    {
        emit TaskProgressStatusUpdate(task.id, task.progressStatus);
    }

    function EmitDeleted(Task memory task) internal
    {
        require(!task.isActive, "Task is not valid Delete event");
        emit TaskDeleted(task.id);
    }
}