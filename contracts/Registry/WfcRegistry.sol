pragma solidity ^0.5.0;

import "../utils/StringAsKey.sol";

import "./IWfcRegistry.sol";

/** 
 *@dev registry contract controlled by the Dao that contains the address of storage and logical contracts and their matchings
*/
contract WfcRegistry is IWfcRegistry {
  
    using StringAsKey for string;

    modifier notZeroAddress(address _address) {
        require(_address != address(0), "zero address not allowed");
        _;
    }

    /**
     * @dev constructor that sets the Dao ownership
     */
    constructor(address _ownerDao) public OwnableDao(_ownerDao) {
    }

    /**
     * @dev See {IWfcRegistry-addLogicalContract}
     */
    function addLogicalContract(string calldata _contractName, address _contractAddress) external onlyOwnerDao notZeroAddress(_contractAddress) {
        bytes32 contractName = _contractName.convert();
        _addContract(contractName, _contractAddress, ContractType.LOGICAL);
        emit AddLogicalContractLog(_contractName, _contractAddress);
    }

    /**
     * @dev See {IWfcRegistry-addStorageContract}
     */
    function addStorageContract(string calldata _contractName, address _contractAddress) external onlyOwnerDao notZeroAddress(_contractAddress) {
        bytes32 contractName = _contractName.convert();
        _addContract(contractName, _contractAddress, ContractType.STORAGE);
        emit AddStorageContractLog(_contractName, _contractAddress);
    }

    /**
     * @dev See {IWfcRegistry-updateLogicalContract}
     */
    function updateLogicalContract(string calldata _contractName, address _newContractAddress) external onlyOwnerDao notZeroAddress(_newContractAddress) {
        bytes32 contractName = _contractName.convert();
        address previousAddress = logicalContracts[contractName];
        _updateContract(contractName, _newContractAddress, ContractType.LOGICAL);
        emit UpdateLogicalContractLog(_contractName, previousAddress, _newContractAddress);
    }

    /*
     * @dev See {IWfcRegistry-updateStorageContract}
     */
    function updateStorageContract(string calldata _contractName, address _newContractAddress) external onlyOwnerDao notZeroAddress(_newContractAddress) {
        bytes32 contractName = _contractName.convert();
        address previousAddress = logicalContracts[contractName];
        _updateContract(contractName, _newContractAddress, ContractType.STORAGE);
        emit UpdateStorageContractLog(_contractName, previousAddress, _newContractAddress);
    }

    /*
     * @dev See {IWfcRegistry-deleteLogicalContract}
     */
    function deleteLogicalContract(string calldata _contractName) external onlyOwnerDao {
        bytes32 contractName = _contractName.convert();
        address previousAddress = logicalContracts[contractName];
        _updateContract(contractName, address(0), ContractType.LOGICAL);
        emit UpdateLogicalContractLog(_contractName, previousAddress, address(0));
    }
    
    /*
     * @dev See {IWfcRegistry-deleteStorageContract}
     */
    function deleteStorageContract(string calldata _contractName) external onlyOwnerDao {
        bytes32 contractName = _contractName.convert();
        address previousAddress = logicalContracts[contractName];
        _updateContract(contractName, address(0), ContractType.STORAGE);
        emit UpdateStorageContractLog(_contractName, previousAddress, address(0));
    }

    /*
     * @dev See {IWfcRegistry-setAllowedContracts}
     */
    function setAllowedContracts(string calldata _storageContractName, string calldata _logicalContractName, bool _isAllowed) external onlyOwnerDao {
        bytes32 storageContractName = _storageContractName.convert();
        bytes32 logicalContractName = _logicalContractName.convert();
        require(logicalContracts[logicalContractName] != address(0) && storageContracts[storageContractName] != address(0), "Contract not registred");
        address storageAddress = storageContracts[storageContractName];
        address logicalAddress = logicalContracts[logicalContractName];
        bool previous = isAllowed[storageAddress][logicalAddress];
        isAllowed[storageAddress][logicalAddress] = _isAllowed;
        emit SetAllowedContractsLog(storageAddress, logicalAddress, previous, _isAllowed);
    }

    /*
     * @dev See {IWfcRegistry-deployAndAddContract}
     */
    function deployAndAddContract(bytes memory _contractByteCode, uint256 _amount, string memory _contractName, ContractType _contractType) public payable onlyOwnerDao {
        address target;
        assembly {
            target := create(_amount, add(_contractByteCode, 0x20), mload(_contractByteCode))
            switch iszero(extcodesize(target))
            case 1 {
                // throw if contract failed to deploy
                revert(0, 0)
            }
        }
        bytes32 contractName = _contractName.convert();
        _addContract(contractName, target, _contractType);
        if (_contractType == ContractType.LOGICAL) {
            emit AddLogicalContractLog(_contractName, target);
        } else {
            emit AddStorageContractLog(_contractName, target);
        }
    }

    /*
     * @dev See {IWfcRegistry-deployAndUpdateContract}
     */
    function deployAndUpdateContract(bytes memory _contractByteCode, uint256 _amount, string memory _contractName, ContractType _contractType) public payable onlyOwnerDao {
        address target;
        assembly {
            target := create(_amount, add(_contractByteCode, 0x20), mload(_contractByteCode))
            switch iszero(extcodesize(target))
            case 1 {
                // throw if contract failed to deploy
                revert(0, 0)
            }
        }
        bytes32 contractName = _contractName.convert();
        address previousAddress = logicalContracts[contractName];
        _updateContract(contractName, target, _contractType);
        if (_contractType == ContractType.LOGICAL) {
            emit UpdateLogicalContractLog(_contractName, previousAddress, target);
        } else {
            emit UpdateStorageContractLog(_contractName, previousAddress, target);
        }
    }
    
    /*
     * @dev internal function that allows to add a contract in the registry
     */
    function _addContract(bytes32 _contractName, address _contractAddress, ContractType _contractType ) internal {
        if (_contractType == ContractType.LOGICAL) {
            require(logicalContracts[_contractName] == address(0), "Logical contract already added"); 
            logicalContracts[_contractName] = _contractAddress;
        } else {
            require(storageContracts[_contractName] == address(0), "Logical contract already added"); 
            storageContracts[_contractName] = _contractAddress;
        }
    }

    /*
     * @dev internal function that allows to update a contract in the registry
     */
    function _updateContract(bytes32 _contractName, address _newContractAddress, ContractType _contractType ) internal {
        if (_contractType == ContractType.LOGICAL) {
            require(logicalContracts[_contractName] != address(0), "Logical contract already added"); 
            logicalContracts[_contractName] = _newContractAddress;
        } else {
            require(storageContracts[_contractName] != address(0), "Logical contract already added"); 
            storageContracts[_contractName] = _newContractAddress;
        }
    }
}


