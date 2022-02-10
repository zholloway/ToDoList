pragma solidity > 0.5.0;

import { Task, ProgressStatus } from "../structs/Task.sol";

library TaskEventLibrary
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

    function EmitTaskCreated(
        Task memory _task
    )
    internal
    {
        emit TaskCreated(_task.id, _task.content);
    }

    function EmitTaskProgressStatusUpdate(
        Task memory _task
    )
    internal
    {
        emit TaskProgressStatusUpdate(_task.id, _task.progressStatus);
    }

    function EmitTaskDeleted(
        Task memory _task
    )
    internal
    {
        emit TaskDeleted(_task.id);
    }
}