import React, { Component } from 'react'
import PropTypes from 'prop-types'




//inline styles
const styles = {
  backgroundColor: '#F9DBDB',
  color: 'black',
  fontFamily: "'Open Sans', sans-serif",
  fontSize: "14pt",
  padding: 30,
  marginRight:'1100px',
}

class Home extends Component {
  constructor(props, context) {
    super(props)
    this.contracts = context.drizzle.contracts
  }

 

  render() {
	 
    return (
	<div> hello Organizations </div>
	)
	
      
  }
}

Home.contextTypes = {
  drizzle: PropTypes.object
}

export default Home
