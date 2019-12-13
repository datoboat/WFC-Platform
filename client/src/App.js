import React, { Component } from 'react'
import { Route } from 'react-router-dom'

import HomeContainer from './layouts/components/home/HomeContainer'
import OrganizationsContainer from './layouts/components/organizations/OrganizationsContainer'
import DonorsContainer from './layouts/components/donors/DonorsContainer'

// Styles  
import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

const styles = {
position:'absolute',
left:'500px',
top:'100px'
};

class App extends Component {
  render() {
    return (
       <div>
         <Route exact path="/" component={HomeContainer} />
		 <Route path="/Organizations" component={OrganizationsContainer} />
		 <Route path="/Donors" component={DonorsContainer} />
       </div>
	);
  }
}

/**/

export default App
