pragma solidity ^0.5.0;

import "../Registry/IWfcRegistry.sol";

import "./IWfcManagmentStorage.sol";

/**
 * @dev Storage contract implementing all getter and setter of the variables 
 * that allow correct working of Wfc platform managed by the Dao
 */
contract WfcManagmentStorage is IWfcManagmentStorage {
    
    /**
     * @dev address of the registry this contract is linked to
     */
    IWfcRegistry public wfcRegistry;

    /**
     * @dev mapping that contain address of the allowed token used for donations
     */
    mapping(address => bool) private tokenAddress;

    /**
     * @dev mapping that contain allowed service lines
     */
    mapping(bytes32 => bool) private serviceLines;

    /**
     * @dev mapping that contain splitting percentages of the donations
     */
    mapping(bytes32 => uint256) private donationSplit;

    /**
     * @dev mapping that contain settings for the correct work of the platform
     */
    mapping(bytes32 => uint256) private settings;

    modifier onlyAllowedLogicalContract {
        require(wfcRegistry.isAllowed(address(this), msg.sender), "Sender is not allowed");
        _;
    }

    /**
     * @dev constructor that sets the address of the registry
     */
    constructor(IWfcRegistry _wfcRegistry) public {
        require(address(_wfcRegistry) != address(0), "Registry address is null");
        wfcRegistry = _wfcRegistry;
    }

    /**
     * @dev See {IWfcManagmentStorage-setTokenAddress}
     */
    function setTokenAddress(address _tokenAddress, bool _isActivated) external onlyAllowedLogicalContract {
        tokenAddress[_tokenAddress] = _isActivated;
    }

    /**
     * @dev See {IWfcManagmentStorage-getTokenAddress}
     */
    function getTokenAddress(address _tokenAddress) public view returns(bool) {
        return tokenAddress[_tokenAddress];
    }

    /**
     * @dev See {IWfcManagmentStorage-setServiceLine}
     */
    function setServiceLine(bytes32 _ServiceLineName, bool _isActivated) external onlyAllowedLogicalContract {
        serviceLines[_ServiceLineName] = _isActivated;
    }

    /**
     * @dev See {IWfcManagmentStorage-getServiceLine}
     */
    function getServiceLine(bytes32 _ServiceLineName) public view  returns(bool) {
        return serviceLines[_ServiceLineName];
    }

    /**
     * @dev See {IWfcManagmentStorage-setDonationSplit}
     */
    function setDonationSplit(bytes32 _donationSplitName, uint256 _percentage) external onlyAllowedLogicalContract {
        donationSplit[_donationSplitName] = _percentage;
    }

    /**
     * @dev See {IWfcManagmentStorage-getDonationSplit}
     */
    function getDonationSplit(bytes32 _donationSplitName) public view returns(uint256) {
        return donationSplit[_donationSplitName];
    }

    /**
     * @dev See {IWfcManagmentStorage-setSettings}
     */
    function setSettings(bytes32 _settingName, uint256 _value) external onlyAllowedLogicalContract {
        settings[_settingName] = _value;
    }

    /**
     * @dev See {IWfcManagmentStorage-getSettings}
     */
    function getSettings(bytes32 _settingName) public view returns(uint256) {
        return settings[_settingName];
    }
}