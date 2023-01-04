export const getFormattedDateTime = (date = new Date(), variant = 'long') => {
  const formated_date = date.toLocaleDateString('nl', {
    year: 'numeric',
    month: variant,
    day: '2-digit',
    
  })
  const formated_time = date.toLocaleTimeString('nl', {
    hour: 'numeric',
    minute: '2-digit'
  })

  const formated = variant === 'short'
    ? `${formated_date} - ${formated_time}`
    : `${formated_date} at ${formated_time}`

  return formated
}