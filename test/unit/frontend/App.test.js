
import { render, screen } from '@testing-library/react';
import App from '../../src/App'; // Путь к App.js

test('renders App component', () => {
  render(<App />);
  const element = screen.getByText(/welcome/i); // Замени на текст из твоего App.js
  expect(element).toBeInTheDocument();
});