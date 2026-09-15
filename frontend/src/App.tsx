import { Route, Routes } from 'react-router-dom';
import { AppLayout } from './components/layout/AppLayout';
import { SectionPage } from './pages/SectionPage';

function App() {
  return (
    <Routes>
      <Route element={<AppLayout />}>
        <Route index element={<SectionPage section="home" />} />
        <Route path="catalog" element={<SectionPage section="catalog" />} />
        <Route path="my-path" element={<SectionPage section="myPath" />} />
        <Route path="*" element={<SectionPage section="notFound" />} />
      </Route>
    </Routes>
  );
}

export default App;
