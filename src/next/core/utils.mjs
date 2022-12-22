export const getFormattedDateTime = (date = new Date()) => {
  const formated_date = date.toLocaleDateString('nl', {
    year: 'numeric',
    month: 'long',
    day: '2-digit',
    
  })
  const fomrated_time = date.toLocaleTimeString('nl', {
    hour: 'numeric',
    minute: '2-digit'
  })

  const formated = `${formated_date} at ${fomrated_time}`

  return formated
}