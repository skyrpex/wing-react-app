import {Link} from "react-router-dom";

const style = {
  header: {
    display: "flex",
    justifyContent: "center",
    margin: "60px",
    color: "black",
  },
  img: {
    height: "60px",
  },
};

export const Header = () => (
  <Link as="div" to="/" style={style.header}>
    <img src="/winglang-logo-dark.png" alt="logo" style={style.img} />
    <h1>File system</h1>
  </Link>
);
