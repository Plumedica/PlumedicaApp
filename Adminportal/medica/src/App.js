import Register from "./components/register_page.js";
import './App.css';
import Login from './components/login_page.js';
import {BrowserRouter , Route, Routes} from 'react-router-dom';


function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/Login" element={<Login />} />
        <Route path="/" element={<Register />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;