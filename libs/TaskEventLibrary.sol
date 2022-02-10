pragma solidity > 0.5.0;

import { Task } from "../structs/Task.sol";

library TaskEventLibrary
{
    event TaskCreated(
        uint256 taskId,
        string content
    );

    event TaskCompleted
    (
        uint256 taskId
    );

    function EmitTaskCreated(
        Task memory _task
    )
    internal
    {
        emit TaskCreated(_task.id, _task.content);
    }

    function EmitTaskCompleted(
        Task memory _task
    )
    internal
    {
        emit TaskCompleted(_task.id);
    }
}