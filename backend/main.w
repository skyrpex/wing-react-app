bring ex;
bring cloud;
bring http;
bring util;
bring expect;
bring math;
bring fs;
bring "./filestorage.w" as f;





let fileStorage = new f.FileStorage();

let expectJsonEqual = inflight (a: Json, b: Json) => {
  expect.equal(Json.stringify(a), Json.stringify(b));
};

let website = new ex.ReactApp(
  projectPath: "./../client",
  // localPort: math.round(4000 + math.random(4000))
);
  
let api = new cloud.Api(
  cors: true,
  corsOptions: {
    allowHeaders: ["*"],
    allowMethods: [
      http.HttpMethod.OPTIONS, 
      http.HttpMethod.GET, 
      http.HttpMethod.POST, 
      http.HttpMethod.DELETE, 
      http.HttpMethod.PUT,
      http.HttpMethod.HEAD
    ],
  }
);

website.addEnvironment("apiUrl", api.url);

// lists the folders in the 
api.get("/api/folders", inflight (req) => {
  let folders = MutSet<str>{};
  for f in fileStorage.listDirectory("") {
    if f.type == "dir" {
      folders.add(f.path);
    }
  } 
  return {
    status: 200,
    body: Json.stringify(folders.toArray())
  };
});

// lists the folders in the 
api.post("/api/folders", inflight (req) => {
  let folder = Json.parse(req.body ?? "error").get("folder").asStr();
  fileStorage.addDirectory("/{folder}");
  return {
    status: 200,
    body: str.fromJson(folder)
  };
});

// reads the content of a folder
api.get("/api/folders/:folder", inflight (req) => {
  let folder = req.vars.get("folder");
  let files = fileStorage.listDirectory("/{folder}");
  let res = MutArray<str>[];
  for f in files {
    if f.type == "file" {
      res.push(fs.basename(f.path));
    }
  }
  return {
    status: 200,
    body: Json.stringify(res)
  };
});

// reads the content of a file in a folder
api.get("/api/folders/:folder/:file", inflight (req) => {
  return {
    status: 200,
    body: fileStorage.readFile("/{req.vars.get("folder")}/{req.vars.get("file")}")
  };
  
});

// puts a file in the folder
api.put("/api/folders/:folder/:file", inflight (req) => {
  let f = req.vars.get("folder");
  let file = req.vars.get("file");
  let filename = "/{f}/{file}";
  let  content = req.body ?? "";
  fileStorage.addFile(filename, content); 
  return {
    status: 200,
    body: Json.stringify({filename: filename, content: content})
  };
});

let url = api.url;

// new checks.Check(inflight () => {
//   let url = api.url;
//   let folderName = util.nanoid();
//   let res = http.post(url + "/api/folders", body: Json.stringify({ folder: folderName }));
//   let j = Json.parse(http.get(url + "/api/folders").body);
//   let ar = Json.values(j);
//   assert(ar.contains(Json "/{folderName}/"));
// }) as "create folder";


// new checks.Check(inflight () => {
//   let url = api.url;
//   let folderName = util.nanoid();
//   http.post(url + "/api/folders", body: Json.stringify({ folder: folderName }));
  
//   let fileName = util.nanoid();
//   http.put(url + "/api/folders/{folderName}/{fileName}", body: "lorem ipsum");

//   let j = Json.parse(http.get(url + "/api/folders/{folderName}").body);
//   let ar = Json.values(j);
//   assert(ar.contains(Json fileName));

//   let fileContent = http.get(url + "/api/folders/{folderName}/{fileName}").body;
//   assert("lorem ipsum" == fileContent);
// }) as "create file";

