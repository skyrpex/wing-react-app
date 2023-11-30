import React from "react";

// function App() {
//   let [folders, setFolders] = useState([])
//   let fetchAFolder = (f) => {
//     return fetch(window.wingEnv.apiUrl + "/api/folders/"+ f)
//     .then(response => response.json())
//     .then(data => setFolders(data))
//   }
//   let fetchAllFolders = () => {
//     return fetch(window.wingEnv.apiUrl + "/api/folders/")
//     .then(response => response.json())
//     .then(data => setFolders(data))
//   }
//   useEffect(() => {
//     fetchAllFolders();
//   },[])

//   return (
//     <div className="App">
//     { folders.map(item => <div key={item} onClick={() => fetchAFolder(item)}>{item}</div>) }
//     <button onClick={fetchAllFolders}>Refresh</button>
//     </div>

//   );
// }

import {BrowserRouter, Route, Routes} from "react-router-dom";
import {Header} from "./header";
import {InFolderView} from "./folder-inner-view";
import {RootView} from "./root-view";
import "semantic-ui-css/semantic.min.css";

const App = () => {
  return (
    <BrowserRouter>
      <Header />
      <div>
        <Routes>
          <Route path="/:folder" element={<InFolderView />} />
          <Route path="/" element={<RootView />} />
        </Routes>
      </div>
    </BrowserRouter>
  );
};

export default App;
