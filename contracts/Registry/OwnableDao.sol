pragma solidity ^0.5.0;

contract OwnableDao {
    address internal ownerDao;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor (address _ownerDao) internal {
        require(_ownerDao != address(0));
        ownerDao = _ownerDao;
        emit OwnershipTransferred(address(0), _ownerDao);
    }



    /**
     * @return the address of the owner.
     */
    function getOwnerDao() public view returns (address) {
        return ownerDao;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwnerDao() {
        require(isOwnerDao());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwnerDao() public view returns (bool) {
        return msg.sender == ownerDao;
    }

   
    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwnerDao The address to transfer ownership to.
     */
    function transferOwnershipDao(address newOwnerDao) public onlyOwnerDao {
        _transferOwnershipDao(newOwnerDao);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwnerDao The address to transfer ownership to.
     */
    function _transferOwnershipDao(address newOwnerDao) internal {
        require(newOwnerDao != address(0));
        emit OwnershipTransferred(ownerDao, newOwnerDao);
        ownerDao = newOwnerDao;
    }
}

