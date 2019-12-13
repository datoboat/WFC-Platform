import createHistory from 'history/createBrowserHistory'
import { createStore, applyMiddleware, compose } from 'redux'
import thunkMiddleware from 'redux-thunk'
import { routerMiddleware } from 'react-router-redux'
import reducer from './reducer'
import rootSaga from './rootSaga'
import createSagaMiddleware from 'redux-saga'
import { generateContractsInitialState } from 'drizzle'
import drizzleOptions from './drizzleOptions'

// Redux DevTools
const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;  //serve per il supportoall'estensione browser devtool, si applica ai middleware

const history = createHistory()    //crea storia del browser, serve per poter creare routerniddleware

const routingMiddleware = routerMiddleware(history) //routing middlware, quando il browser cambia url, viene generata un'azione che attiva routing middleware che modifica l'history e genera una nuova azione che viene eseguita dal routing reducer e aggiorna il campo routing dello store, se si utilizza il ConnectRouer questo legge l'history dallo stato dello store e non da un suo stato interno come Router e cos' anche le varie componenti di ciascuna rotta >>> serve per abilitare devtools, preserva la regola di tutto nello store, se non si usa comunque l'history viene aggiornata e passata dalla comp. Router alle componenti delle Route interne 
const sagaMiddleware = createSagaMiddleware()  //instanzia un middleare di tipo saga

const initialState = {
  contracts: generateContractsInitialState(drizzleOptions)    //stato iniziale creato analogamente al generatestore di drizzle e inserisce come contratti ed i relativi eventi solo quelli contenuti nelle drizzle options
}

const store = createStore(      //crea un redux store con i reducer default+routing, stato iniziale e middleware thunk,routing e sagas rispettivamente   
  reducer,
  initialState,
  composeEnhancers(
    applyMiddleware(
      thunkMiddleware,      //middleware che viene attivato se l'azione è una funzione e non un oggetto (ad esempio se l'action creator genera una funzione e non un oggetto), la funzione ha come parametri getstate e dispatch per poter leggere stati ed eseguire altre azione >>> si usa quando si ha la necessità di eseguire chiamate asincrone, si esegue un azione per la request poi then aspetta la risoluzione per eseguire un azione resolved o rejected tutto in un'unica azione iniziale, senza thunk azioni solo pure quindi è necessario che nell'action creator venga gestita l'asincronicità e poi dato risultato finale dispatch.(azione oggetto) e il dispatch viene passato anch'esso come parametro dell'action creator >>> maggiore complesità codice, le componenti passando dispatch capiscono che l'azione comporta chiamate asincrone
      routingMiddleware,   //descritto sopra
      sagaMiddleware       //middleware che è costituito da sagas cioè generatori cioè funzioni che si comportano come iteratori (quando avviene uno yeld viene salvato il value) e una volta ilrichiamati il prossimo value fino ad un retrun o fine codice, utilizza effects (put,call,take,select,fork, takelast, takevery) per gestire chaiamte asincrone, dispatch, filtri su azioni, parallelismo, non blocking.... >>> vantaggi su thunk:evita callback >> sintassi più facile, più facile il testing in quanto l'assert avviene rispeetto all'effect di una promis non la promie stessa (scatola nera)
    )
  )
)

sagaMiddleware.run(rootSaga)  //attiva il middleware ti tipo saga con la root saga di default di drizzle conentente tutte le fork delle sagas di default della libreria Drizzle

export { history }
export { store }

export default store
