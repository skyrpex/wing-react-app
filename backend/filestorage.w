bring ex;
bring cloud;
bring util;


pub struct Entry {
  path: str;
  type: str;
  key: str?; // only for files
}

pub class FileStorage {
  index: ex.DynamodbTable;
  store: cloud.Bucket;

  fileType: str;
  dirType: str;

  new() {
    this.fileType = "file";
    this.dirType = "dir";
    
    this.index = new ex.DynamodbTable(
      attributeDefinitions: {
        "path": "S",
      },
      hashKey: "path",
      name: "files",
    );    

    this.store = new cloud.Bucket();
  }

  pub inflight addFile(path: str, body: str) {
    if path.endsWith("/") {
      throw "file name cannot end with '/'";
    }

    let key = util.sha256(body);

    this.index.putItem(item: {
      "path": path,
      "type": this.fileType,
      "key": key,
    });

    this.store.put(key, body);
  }

  pub inflight addDirectory(path: str) {
    let var p = path;
    if !p.endsWith("/") {
      p = p + "/";
    }

    this.index.putItem(item: {
      "path": p,
      "type": this.dirType,
    });
  }

  pub inflight readFile(path: str): str {
    if path.endsWith("/") {
      throw "cannot end with '/'";
    }

    let result = this.index.getItem(key: { path: path });
    let entry = Entry.fromJson(result.item);
    if let key = entry.key {
      return this.store.get(key);
    } else {
      throw "cannot read a directory";
    }
  }

  pub inflight listDirectory(path: str): Array<Entry> {
    let result = this.index.scan(
      filterExpression: "begins_with(#path, :prefix)",
      expressionAttributeNames: { "#path": "path" },
      expressionAttributeValues: { ":prefix": "{path}/" }
    );

    let results = MutArray<Entry>[];
    for i in result.items {
      results.push(Entry.fromJson(i));
    }

    return results.copy();
  }
}