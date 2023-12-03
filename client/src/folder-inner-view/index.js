import {useEffect, useState} from "react";
import {useParams} from "react-router-dom";
import {Button, Divider, Form, Icon, Input, Label, TextArea} from "semantic-ui-react";
import {style} from "./style";

const File = ({file, handleOnClick}) => {
  return (
    <div style={style.folder} onClick={handleOnClick}>
      <Icon name="file outline" size="huge" />
      <Label>{file}</Label>
    </div>
  );
};

export const InFolderView = () => {
  const [folderContent, setFolderContent] = useState([]);
  const [filename, setFilename] = useState("");
  const [fileContent, setFileContent] = useState("");
  const [isEditMode, setIsEditMode] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const {folder} = useParams();

  const getContent = async () => {
    const response = await fetch(`${window.wingEnv.apiUrl}/api/folders/${folder}`);
    setFolderContent(await response.json());
  };

  const chooseFile = async (selected) => {
    setFilename(selected);
    const response = await fetch(`${window.wingEnv.apiUrl}/api/folders/${folder}/${selected}`);
    setFileContent(await response.text());
    setIsEditMode(true);
  };

  const updateFile = async () => {
    setIsLoading(true);
    await fetch(`${window.wingEnv.apiUrl}/api/folders/${folder}/${filename}`, {method: "PUT", body: fileContent});
    await getContent();
    setIsLoading(false);
    reset();
  };

  const reset = () => {
    setFileContent("");
    setFilename("");
    setIsEditMode(false);
  };

  useEffect(() => {
    getContent();
  }, []);

  return (
    <div style={style.main}>
      <div style={style.folders}>
        {folderContent.map((item) => (
          <File key={item} file={item} handleOnClick={() => chooseFile(item)} />
        ))}
        {!folderContent.length && <p>No files yet</p>}
      </div>
      <Divider />
      <div style={style.cta}>
        <h3>Create/Update File:</h3>
        <Form>
          <Form.Field control={Input} label="File Name" placeholder="Name" value={filename} onChange={(e) => setFilename(e.target.value)} disabled={isEditMode} />
          <Form.Field control={TextArea} label="File Content" placeholder="Content" value={fileContent} onChange={(e) => setFileContent(e.target.value)} />
          <Button type="submit" onClick={reset}>
            Cancel
          </Button>
          <Button loading={isLoading} type="submit" color="blue" onClick={updateFile}>
            {isEditMode ? `Update ${filename}` : "Create new"}
          </Button>
        </Form>
        <div></div>
      </div>
    </div>
  );
};
