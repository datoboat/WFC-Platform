pragma solidity ^0.5.0;

/**
 *@dev abstract contract for storage of variables managed by the Dao for the correct working of Wfc platform
 */
contract IWfcManagmentStorage {
    /*
     * @dev setter of the token addresses used as payment currency for the donations
     */
    function setTokenAddress(address _tokenAddress, bool _isActivated) external;

    /*
     *@ dev getter of the token addresses used as payment currency for the donations
     */
    function getTokenAddress(address _tokenAddress) public view returns(bool);

    /*
     * @dev setter of the service line on the Wfc platform
     */
    function setServiceLine(bytes32 _ServiceLineName, bool _isActivated) external;

    /*
     * @dev getter of the service line on the Wfc platform
     */
    function getServiceLine(bytes32 _ServiceLineName) public view returns(bool);

    /*
     * @dev setter of the splitting percentages of the donation between reserve, 
     * donation, same service line, all service line and the team
     */
    function setDonationSplit(bytes32 _donationSplitName, uint256 _percentage) external;

    /*
     * @dev getter of the splitting percentages of the donation between reserve, 
     * donation, smae service line, all service line and the team
     */
    function getDonationSplit(bytes32 _donationSplitName) public view returns(uint256);

    /**
     * @dev setter of Wfc platform general settings
     */
    function setSetting(bytes32 _settingName, uint256 _value) external;

    /**
     * @dev getter of Wfc platform general settings
     */
    function getSetting(bytes32 _settingName) public view returns(uint256);
}