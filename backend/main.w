bring ex;
bring cloud;
bring http;
bring util;

let api = new cloud.Api(
  cors: true,
  corsOptions: {
    allowHeaders: ["*"],
    allowMethods: [http.HttpMethod.OPTIONS, http.HttpMethod.GET, http.HttpMethod.PUT],
  },
);

let website = new ex.ReactApp(
  projectPath: "./../client",
  localPort: 4001,
);

// lists the folders in the 
api.get("/api/folders", inflight (req) => {
  return {
    status: 200,
    body: Json.stringify(["a", "b", "c", "d", "e", "f"])
  };
});

// lists the folders in the 
api.post("/api/folder", inflight (req) => {
  let folder = Json.parse(req.body ?? "").get("folder");
  return {
    status: 200,
    body: str.fromJson(folder)
  };
});

// reads the content of a folder
api.get("/api/folders/:folder", inflight (req) => {
  let f = req.vars.get("folder");
  return {
    status: 200,
    body: Json.stringify(["{f}a.txt", "{f}b.txt"])
  };
});

// reads the content of a file in a folder
api.get("/api/folders/:folder/:file", inflight (req) => {
  let f = req.vars.get("folder");
  return {
    status: 200,
    body: "hello wing"
  };
});

// puts a file in the folder
api.put("/api/folders/:folder/:file", inflight (req) => {
  let f = req.vars.get("folder");
  let file = req.vars.get("file");
  let filename = "{f}/{file}";
  let content = str.fromJson(Json.parse(req.body ?? "").get("content"));
  return {
    status: 200,
    body: Json.stringify({filename: filename, content: content})
  };
});


website.addEnvironment("name", "like");
website.addEnvironment("apiUrl", api.url);