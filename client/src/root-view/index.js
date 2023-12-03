import {useEffect, useState} from "react";
import {Link} from "react-router-dom";
import {Button, Divider, Icon, Input, Form, Label} from "semantic-ui-react";
import {style} from "./style";

const Folder = ({folder}) => {
  const [isHover, setIsOver] = useState(false);

  return (
    <Link to={`${folder}`} as="div" style={style.folder} onMouseOver={() => setIsOver(true)} onMouseOut={() => setIsOver(false)}>
      <Icon name={isHover ? "folder open outline" : "folder outline"} size="huge" />
      <Label>{folder}</Label>
    </Link>
  );
};

export const RootView = () => {
  const [folders, setFolders] = useState([]);
  const [folderName, setFolderName] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  const getFolders = async () => {
    const response = await fetch(`${window.wingEnv.apiUrl}/api/folders`);
    setFolders(await response.json());
  };

  const addFolder = async () => {
    setIsLoading(true);
    await fetch(`${window.wingEnv.apiUrl}/api/folders`, {method: "POST", body: JSON.stringify({folder: folderName})});
    await getFolders();
    setFolderName("");
    setIsLoading(false);
  };

  useEffect(() => {
    getFolders();
  }, []);

  return (
    <div style={style.main}>
      <div style={style.folders}>
        {folders.map((folder) => (
          <Folder key={folder} folder={folder} />
        ))}
        {!folders.length && <p>No Folders yet.</p>}
      </div>
      <Divider />
      <div style={style.cta}>
        <Form>
          <h3>Create a Folder</h3>
          <Form.Field control={Input} error={folders.includes(folderName) && <p style={style.error}>{folderName} already exists.</p>} type="text" label="Folder Name" placeholder="Name" value={folderName} onChange={(e) => setFolderName(e.target.value)} />
          <Button type="cancel" onClick={() => setFolderName("")}>
            Cancel
          </Button>
          <Button loading={isLoading} type="submit" color="blue" disabled={folders.includes(folderName) || !folderName} onClick={addFolder}>
            Add Folder!
          </Button>
        </Form>
      </div>
    </div>
  );
};
