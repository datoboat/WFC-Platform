import { all, fork } from 'redux-saga/effects'
import { drizzleSagas } from 'drizzle'

export default function* root() {
  yield all(
    drizzleSagas.map(saga => fork(saga))   //fork di tutte le drizzle sagas di default per gestire le azioni della porzione di store gestita da drizzle tramite middleware, all serve per riunire tutte le sagas ed eseguirle in parallelo, fork permette di eseguire una sagas anche se non è terminata l'esecuzione di tutte le altre (senza fork tutte le sgas in parallelo devono essere terminate per poter inizare una nuova esecuzione in parallelo)
  )
}