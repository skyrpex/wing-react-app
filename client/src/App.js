import React, {useState, useEffect} from 'react';
import './App.css';


function App() {
  let [folders, setFolders] = useState([])
  let fetchAFolder = (f) => {
    return fetch(window.wingEnv.apiUrl + "/api/folders/"+ f)
    .then(response => response.json())
    .then(data => setFolders(data))
  }
  let fetchAllFolders = () => {
    return fetch(window.wingEnv.apiUrl + "/api/folders/")
    .then(response => response.json())
    .then(data => setFolders(data))
  }
  useEffect(() => {
    fetchAllFolders();
  },[])

  return (
    <div className="App">
    { folders.map(item => <div key={item} onClick={() => fetchAFolder(item)}>{item}</div>) }
    <button onClick={fetchAllFolders}>Refresh</button>
    </div>
    
  );
}

export default App;