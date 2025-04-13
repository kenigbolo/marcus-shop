import '@testing-library/jest-dom'
import { server } from './mocks/server'

// Start MSW before each test
beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())
