pragma solidity ^0.5.0;

import "./OwnableDao.sol";

/** 
 *@dev abstract contract with functions, mappings and events for Registry contract
*/
contract IWfcRegistry is OwnableDao {
    /**
     * @dev mapping with key the name of the logical contract and value its address
     */
    mapping(bytes32 => address) public logicalContracts;

    /**
     * @dev mapping with key the name of the storage contract and value its address
     */
    mapping(bytes32 => address) public storageContracts;

    /**
     * @dev mapping with keys storage contract address and logical contract address and value 
     * a bool variable that indicate if the storage contract can receive calls from the logical one
     */
    mapping(address => mapping (address => bool)) public isAllowed;

    enum ContractType {LOGICAL, STORAGE}

    /**
     * @dev function that allows the Dao to add a logical contract in the registry
     */
    function addLogicalContract(string calldata _contractName, address _contractAddress) external;

    /**
     * @dev function that allows the Dao to add a storage contract in the registry
     */
    function addStorageContract(string calldata _contractName, address _contractAddress) external;

    /**
     * @dev function that allows the Dao to update a logical contract in the registry
     */
    function updateLogicalContract(string calldata _contractName, address _newContractAddress) external;

    /**
     * @dev function that allows the Dao to update a storage contract in the registry
     */
    function updateStorageContract(string calldata _contractName, address _newContractAddress) external;

    /**
     * @dev function that allows the Dao to delete a logical contract in the registry
     */
    function deleteLogicalContract(string calldata _contractName) external;

    /**
     * @dev function that allows the Dao to delete a storage contract in the registry
     */
    function deleteStorageContract(string calldata _contractName) external;

    /**
     * @dev function that allows to add or eliminate the link between a storage and a logical contract
     */
    function setAllowedContracts (string calldata _storageContractName, string calldata _logicalContractName, bool _isAllowed) external;

    /**
     * @dev function that allows to create a new contract and add it to the registry
     */
    function deployAndAddContract(bytes memory _contractByteCode, uint256 _amount, string memory _contractName, ContractType _contractType) public payable;

    /**
     * @dev function that allows to create a new contract and update it to the registry
     */
    function deployAndUpdateContract(bytes memory _contractByteCode, uint256 _amount, string memory _contractName, ContractType _contractType) public payable;

    /**
     * @dev event emitted when a logical contract is added in the registry
     */
    event AddLogicalContractLog(string indexed _contractName, address indexed _contractAddress);

    /**
     * @dev event emitted when a storage contract is added in the registry
     */
    event AddStorageContractLog(string indexed _contractName, address indexed _contractAddress);

    /**
     * @dev event emitted when a logical contract is updated in the registry
     */
    event UpdateLogicalContractLog(string indexed _contractName, address indexed _previousAddress, address indexed _newContractAddress);

    /**
     * @dev event emitted when a storage contract is updated in the registry
     */
    event UpdateStorageContractLog(string indexed _contractName, address indexed _previousAddress, address indexed _newContractAddress);

    /**
     * @dev event emitted when a link beetween logical contract and storage contract is created or removed
     */
    event SetAllowedContractsLog(address indexed _storageContractName, address indexed _logicalContractName, bool _previous, bool _isAllowed);
}

    