import WfcHelpRequestLogical from './contracts/WfcHelpRequestLogical.json'

const drizzleOptions = {      
  web3: {
    block: false,
    fallback: {
      type: 'ws',
      url: 'ws://127.0.0.1:8545'
    }
  },
  contracts: [
    WfcHelpRequestLogical
  ],
  events: {
    WfcHelpRequestLogical: ['RegistrationRequestLog', 'RegistrationApproved', 'RegistrationRefused', 'RegistrationRevoked', 'RegitrationChanged', 'RegistrationBlocked', 'RequireDaoInvestigationLog', 'InvestigationStop', 'FundraisingSubmittedLog', 'FundraisingRevokedLog', 'FundraisingRefusedLog', 'FundraisingApprovedLog', 'FundraisingCreatedLog']
  },
  polls: {
    accounts: 1500,
	blocks: 1500
  }
}

export default drizzleOptions
