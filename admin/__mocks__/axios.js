const mockAxios = {
  get: vi.fn(),
  post: vi.fn(),
  put: vi.fn(),
  delete: vi.fn()
}

export default {
  create: vi.fn(() => mockAxios)
}
