import { Route, Routes } from 'react-router-dom';
import { ApiStatusPage } from './pages/ApiStatusPage';

function App() {
  return (
    <Routes>
      <Route path="/" element={<ApiStatusPage />} />
      <Route path="*" element={<ApiStatusPage />} />
    </Routes>
  );
}

export default App;
