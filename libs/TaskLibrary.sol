pragma solidity > 0.5.0;

library TaskLibrary
{
    function multiply(
        int v1, 
        int v2
    ) 
    public 
    pure 
    returns(int result) 
    {
        result = v1 * v2;
    }
}