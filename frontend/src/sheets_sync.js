// Google Sheets sync via Apps Script
export const SHEETS_URL = 'https://script.google.com/macros/s/AKfycbxXe5l7ntnmQsQwwiyt3NgHlp9zFQO7_-W98lSrtO9PJzZfhZOow3DrbfkGRwC4wUmVrQ/exec'

export async function sheetsGetAll() {
  try {
    const r = await fetch(SHEETS_URL)
    if (!r.ok) return []
    const data = await r.json()
    return data.results || []
  } catch {
    return []
  }
}

export async function sheetsAdd(entry) {
  try {
    await fetch(SHEETS_URL, {
      method: 'POST',
      body: JSON.stringify({ action: 'add', ...entry })
    })
  } catch {}
}

export async function sheetsDelete(id) {
  try {
    await fetch(SHEETS_URL, {
      method: 'POST',
      body: JSON.stringify({ action: 'delete', id })
    })
  } catch {}
}
