pragma solidity > 0.5.0;

import { Task } from "../structs/Task.sol";
import { ProgressStatus } from "../enums/ProgressStatus.sol";

library TaskEvents
{
    event TaskCreated(
        uint256 taskId,
        string content
    );

    event TaskProgressStatusUpdate (
        uint256 taskId,
        ProgressStatus progressStatus
    );

    event TaskDeleted(
        uint256 _taskId
    );

    function EmitCreated(
        Task memory _task
    )
    internal
    {
        require(_task.isActive && _task.progressStatus == ProgressStatus.New, "Task is not valid Create event");
        emit TaskCreated(_task.id, _task.content);
    }

    function EmitProgressStatusUpdate(
        Task memory _task
    )
    internal
    {
        emit TaskProgressStatusUpdate(_task.id, _task.progressStatus);
    }

    function EmitDeleted(
        Task memory _task
    )
    internal
    {
        require(!_task.isActive, "Task is not valid Delete event");
        emit TaskDeleted(_task.id);
    }
}