const CALENDAR_ID = 'primary';

function doGet() {
  return HtmlService.createTemplateFromFile('Index').evaluate().setTitle('Календарь лаборатории').setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
}

function include(filename) { return HtmlService.createHtmlOutputFromFile(filename).getContent(); }

function getEvents(startIso, endIso) {
  const start = new Date(startIso), end = new Date(endIso);
  if (Number.isNaN(start.getTime()) || Number.isNaN(end.getTime())) throw new Error('Некорректный диапазон дат.');
  return CalendarApp.getCalendarById(CALENDAR_ID).getEvents(start, end).map(serializeEvent);
}

function createEvent(payload) {
  validateEventPayload(payload);
  const calendar = CalendarApp.getCalendarById(CALENDAR_ID), start = new Date(payload.start), end = new Date(payload.end);
  const options = { description: payload.description || '', location: payload.location || '' };
  const event = payload.allDay ? calendar.createAllDayEvent(payload.title, start, options) : calendar.createEvent(payload.title, start, end, options);
  return serializeEvent(event);
}

function updateEvent(payload) {
  validateEventPayload(payload, true);
  const event = CalendarApp.getCalendarById(CALENDAR_ID).getEventById(payload.id);
  if (!event) throw new Error('Событие не найдено.');
  const start = new Date(payload.start), end = new Date(payload.end);
  event.setTitle(payload.title).setDescription(payload.description || '').setLocation(payload.location || '');
  payload.allDay ? event.setAllDayDate(start) : event.setTime(start, end);
  return serializeEvent(event);
}

function deleteEvent(eventId) {
  if (!eventId) throw new Error('Не указан идентификатор события.');
  const event = CalendarApp.getCalendarById(CALENDAR_ID).getEventById(eventId);
  if (!event) throw new Error('Событие не найдено.');
  event.deleteEvent();
  return { id: eventId };
}

function validateEventPayload(payload, requireId) {
  if (!payload || !payload.title || !payload.start || (!payload.allDay && !payload.end)) throw new Error('Заполните название, дату начала и дату окончания.');
  if (requireId && !payload.id) throw new Error('Не указан идентификатор события.');
  if (!payload.allDay && new Date(payload.start) >= new Date(payload.end)) throw new Error('Окончание должно быть позже начала.');
}

function serializeEvent(event) {
  return { id: event.getId(), title: event.getTitle(), description: event.getDescription(), location: event.getLocation(), start: event.getStartTime().toISOString(), end: event.getEndTime().toISOString(), allDay: event.isAllDayEvent() };
}
