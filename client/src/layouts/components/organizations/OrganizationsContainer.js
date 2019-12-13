import Organizations from './Organizations'
import { drizzleConnect } from 'drizzle-react'

// May still need this even with data function to refresh component on updates for this contract.
const mapStateToProps = state => {
  return {
    accounts: state.accounts,
	accountBalances: state.accountBalances,
	WfcHelpRequestLogical: state.contracts.WfcHelpRequestLogical,
    drizzleStatus: state.drizzleStatus,
    transactionStack: state.transactionStack,
    transactions: state.transactions
  }
}

const OrganizationsContainer = drizzleConnect(Organizations, mapStateToProps);

export default OrganizationsContainer
