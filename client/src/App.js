import React from "react";
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
