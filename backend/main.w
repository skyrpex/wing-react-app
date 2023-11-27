bring ex;
bring cloud;
bring http;
bring util;

let api = new cloud.Api(
  cors: true,
  corsOptions: {
    allowHeaders: ["*"],
    allowMethods: [http.HttpMethod.OPTIONS, http.HttpMethod.GET,  ],
  },
);
let website = new ex.ReactApp(
  projectPath: "./../client",
  localPort: 4001,
);

api.get("/api/folders", inflight (req) => {

  return {
    status: 200,
    body: Json.stringify(["a", "b", "c"])
  };
});

api.get("/api/folders/:folder", inflight (req) => {
  let f = req.vars.get("folder");
  return {
    status: 200,
    body: Json.stringify(["{f}a", "{f}b"])
  };
});


website.addEnvironment("name", "like");
website.addEnvironment("apiUrl", api.url);