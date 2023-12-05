bring ex;
bring cloud;
bring http;
bring util;
bring expect;
bring math;
bring fs;
bring "./flat-file-system.w" as f;

let fileStorage = new f.FlatFileSystem();

let expectJsonEqual = inflight (a: Json, b: Json) => {
  expect.equal(Json.stringify(a), Json.stringify(b));
};

let website = new ex.ReactApp(
  projectPath: "./../client",
  localPort: 4002
);
  
let api = new cloud.Api(
  cors: true
);

website.addEnvironment("apiUrl", api.url);

// lists the folders in the 
api.get("/api/folders", inflight (req) => {
  return {
    status: 200,
    body: Json.stringify(fileStorage.listFolders())
  };
});

api.post("/api/folders", inflight (req) => {
  if let body = req.body {
    let folder = Json.parse(body).get("folder").asStr();
    fileStorage.createFolder(folder);
    return {
      status: 200,
      body: str.fromJson(folder)
    };
  }
  return {
      status: 500,
      body: "missing body"
    };
});

// reads the content of a folder
api.get("/api/folders/:folder", inflight (req) => {
  let folder = req.vars.get("folder");
  return {
    status: 200,
    body: Json.stringify(fileStorage.listFiles(folder))
  };
});

// reads the content of a file in a folder
api.get("/api/folders/:folder/:file", inflight (req) => {
  let folder = req.vars.get("folder");
  let file = req.vars.get("file");
  return {
    status: 200,
    body: fileStorage.getFile(folder, file)
  };
});

// puts a file in the folder
api.put("/api/folders/:folder/:file", inflight (req) => {
  let folder = req.vars.get("folder");
  let file = req.vars.get("file");
  let content = req.body ?? "";
  fileStorage.createFile(folder, file, content); 
  return {
    status: 200,
    body: Json.stringify({filename: file, content: content})
  };
});

api.get("/clean", inflight (req) => {
  fileStorage.deleteAll();
  return {
    status: 200,
    body: ""
  };
});



