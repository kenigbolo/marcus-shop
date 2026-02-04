import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  headers: {
    'X-User-ID': import.meta.env.VITE_USER_ID
  }
})

// Global error interceptor for structured logging
api.interceptors.response.use(
  response => response,
  error => {
    const details = {
      message: error?.message,
      status: error?.response?.status,
      url: error?.config?.url,
      method: error?.config?.method,
      requestHeaders: error?.config?.headers,
      responseData: error?.response?.data,
      userAgent: (typeof navigator !== 'undefined' && navigator.userAgent) || null,
      page: (typeof window !== 'undefined' && window.location.href) || null
    }
    console.error('API Error:', details)
    return Promise.reject(error)
  }
)

export default api
