pragma solidity ^0.5.0;

import "./utils/StringAsKey.sol";

import "./Registry/IWfcRegistry.sol";

import "./storage/IWfcManagmentStorage.sol";

/**
 * @dev logical contract that allow Dao to interact with the associated storage contract in order
 * to add and update functionalities of the platform
 */
contract WfcManagmentLogical {

    using StringAsKey for string;

    /**
     * @dev event emitted when a token is set
     */	 
    event SetTokenLog(address indexed _tokenAddress, bool _previous, bool _isActivated);

    /**
     * @dev event emitted when a service line is set
     */	
    event SetServiceLineLog(string indexed _ServiceLineName, bool _previous, bool _isActivated);

    /**
     * @dev event emitted when a donation split percentage is set
     */	
    event SetDonationSplitLog(string indexed _donationSplitName, uint256 _previousValue, uint256 newValue);

    /**
     * @dev event emitted when a platform setting is set
     */	
    event SetSettingLog(string indexed _settingName, uint256 _prevoiusSettingValue, uint256 _newSettingValue);
    
    /**
     * @dev address of the registry this contract is linked to
     */
    IWfcRegistry public wfcRegistry;

    /**
     * @dev name in bytes of storage contract that this contract is linked t through the registry
     */
    bytes32 public storageContractName;
    
    modifier onlyOwnerDao {
        require(msg.sender == wfcRegistry.getOwnerDao(), "Sender different from Dao owner");
        _;
    }

    /**
     * @dev constructor that sets registry address and name of storage contract linked to this contract
     */
    constructor (IWfcRegistry _wfcRegistry, string memory _storageContractName) public {
        require(address(_wfcRegistry) != address(0), "wfcRegistry address is null");
        wfcRegistry = _wfcRegistry;
        storageContractName = _storageContractName.convert();
    }

    /**
     * @dev function that sets if a token is allowed as donation currency
     */
    function setToken (address _tokenAddress, bool _isActivated) external onlyOwnerDao {
        require(_tokenAddress != address(0), "Token address is null");
        IWfcManagmentStorage wfcManagmentStorage = IWfcManagmentStorage(wfcRegistry.storageContracts(storageContractName));
        bool previous = wfcManagmentStorage.getTokenAddress(_tokenAddress);
        wfcManagmentStorage.setTokenAddress(_tokenAddress, _isActivated);
        emit SetTokenLog(_tokenAddress, previous, _isActivated);
    }

    /**
     * @dev function that sets if a service line is allowed 
     */
    function setServiceLine(string calldata _lineName, bool _isActivated) external onlyOwnerDao {
        IWfcManagmentStorage wfcManagmentStorage = IWfcManagmentStorage(wfcRegistry.storageContracts(storageContractName));
        bytes32 lineName = _lineName.convert();
        bool previous = wfcManagmentStorage.getServiceLine(lineName);
        wfcManagmentStorage.setServiceLine(lineName, _isActivated);
        emit SetServiceLineLog(_lineName, previous, _isActivated);
    }
    
    /**
     * @dev function that set the percentage of split of between reserve, 
     * donation, same service line, all service line and the team
     */
    function setDonationSplit(string calldata _donationSplitName, uint256 _splitValue) external onlyOwnerDao {
        IWfcManagmentStorage wfcManagmentStorage = IWfcManagmentStorage(wfcRegistry.storageContracts(storageContractName));
        string memory _totalName = "total";
        bytes32 totalName = _totalName.convert();
        bytes32 donationSplitName = _donationSplitName.convert();
        require(totalName != donationSplitName, "String of donations split equal to total");
        uint256 previousSplitValue = wfcManagmentStorage.getDonationSplit(donationSplitName);
        wfcManagmentStorage.setDonationSplit(donationSplitName, _splitValue);
        emit SetDonationSplitLog(_donationSplitName, previousSplitValue, _splitValue);
        uint256 previousTotalValue = wfcManagmentStorage.getDonationSplit(totalName);
        uint256 newTotalValue = previousTotalValue + _splitValue - previousSplitValue;
        require(newTotalValue < 10000, "Split percentage too high");
        wfcManagmentStorage.setDonationSplit(totalName, newTotalValue);
        emit SetDonationSplitLog(_totalName, previousTotalValue, newTotalValue);
    }

    /**
     * @dev function that set Wfc platform general settings
     */
    function setSetting(string calldata _settingName, uint256 _newSettingValue) external onlyOwnerDao {
        IWfcManagmentStorage wfcManagmentStorage = IWfcManagmentStorage(wfcRegistry.storageContracts(storageContractName));
        bytes32 settingName = _settingName.convert();
        uint256 prevoiusSettingValue = wfcManagmentStorage.getSetting(settingName);
        wfcManagmentStorage.setSetting(settingName, _newSettingValue);
        emit SetSettingLog(_settingName, prevoiusSettingValue, _newSettingValue);
    }
}




