bring ex;
bring cloud;
bring util;

pub class FlatFileSystem {
  db: ex.DynamodbTable;
  blobStore: cloud.Bucket;
  new() {
    this.db = new ex.DynamodbTable(
      attributeDefinitions: {
        "pk": "S",
      },
      hashKey: "pk",
      name: "filesystem",
    );   
    this.blobStore = new cloud.Bucket(); 
  }

  inflight fileKey(folder: str, name: str?): str {
    if let name = name {
      return "file:folder-{folder}:name-{name}";
    }
    return "file:folder-{folder}";
  }
  

  pub inflight createFolder(name: str){
    this.db.putItem(
      item: {
        pk: "dir:{name}",
        name: name
    });
  }
  inflight scan(prefix: str): Array<str> {
    let response = this.db.scan(
      filterExpression: "begins_with(pk, :prefix)",
      expressionAttributeValues: { ":prefix": prefix }
    );
    let result = MutArray<str>[];
    for j in response.items {
      result.push(j.get("name").asStr());
    }
    return result.copy();
  }
  pub inflight listFolders(): Array<str> {
    return this.scan("dir");
  }
  
  

  pub inflight createFile(folder: str, name: str, content: str){
    let key = util.sha256(content);
    this.blobStore.put(key, content);
    this.db.putItem(
      item: {
        pk: this.fileKey(folder, name),
        name: name,
        key: key
    });
  }
  pub inflight listFiles(folder: str): Array<str> {
    return this.scan(this.fileKey(folder));
  }

  pub inflight getFile(folder: str, name: str): str {
    let response = this.db.getItem(
      key: {
        pk: this.fileKey(folder, name)
    });
    return this.blobStore.get(response.item?.get("key")?.asStr() ?? "");
  }
  pub inflight deleteAll() {
    for item in this.db.scan().items {
      this.db.deleteItem(
        key: {
          pk: item.get("pk").asStr()
        }
      );
    }
    
  }
}