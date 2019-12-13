import { combineReducers } from 'redux'
import { routerReducer } from 'react-router-redux'
import { drizzleReducers } from 'drizzle'

const reducer = combineReducers({   //riduttori di defualt della librearia Drizzle (accounts,accountbalance,block,contracts,drizzle status, transactions, transaction stack, web3) + routereducer che modifica lo stato dell'oggetto routing con la nuova route (permette di gestire il routing direttamente nello store e supportare devtools) 
  routing: routerReducer,
  ...drizzleReducers
})

export default reducer
