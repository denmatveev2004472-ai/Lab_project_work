const CALENDAR_ID = 'primary';

function doGet() {
  return HtmlService.createTemplateFromFile('Index')
    .evaluate()
    .setTitle('Календарь лаборатории')
    .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
}

function include(filename) {
  return HtmlService.createHtmlOutputFromFile(filename).getContent();
}

function getCalendar_() {
  const calendar = CalendarApp.getCalendarById(CALENDAR_ID);
  if (!calendar) {
    throw new Error(`Календарь "${CALENDAR_ID}" недоступен.`);
  }
  return calendar;
}

function getEvents(startIso, endIso) {
  const start = new Date(startIso);
  const end = new Date(endIso);

  if (Number.isNaN(start.getTime()) || Number.isNaN(end.getTime())) {
    throw new Error('Некорректный диапазон дат.');
  }

  return getCalendar_().getEvents(start, end).map(serializeEvent_);
}

function createEvent(payload) {
  validateEventPayload_(payload);

  const start = new Date(payload.start);
  const end = new Date(payload.end);
  const options = {
    description: payload.description || '',
    location: payload.location || ''
  };
  const calendar = getCalendar_();
  const event = payload.allDay
    ? calendar.createAllDayEvent(payload.title, start, options)
    : calendar.createEvent(payload.title, start, end, options);

  return serializeEvent_(event);
}

function updateEvent(payload) {
  validateEventPayload_(payload, true);

  const event = getCalendar_().getEventById(payload.id);
  if (!event) {
    throw new Error('Событие не найдено.');
  }

  const start = new Date(payload.start);
  const end = new Date(payload.end);

  event.setTitle(payload.title);
  event.setDescription(payload.description || '');
  event.setLocation(payload.location || '');

  if (payload.allDay) {
    event.setAllDayDate(start);
  } else {
    event.setTime(start, end);
  }

  return serializeEvent_(event);
}

function deleteEvent(eventId) {
  if (!eventId) {
    throw new Error('Не указан идентификатор события.');
  }

  const event = getCalendar_().getEventById(eventId);
  if (!event) {
    throw new Error('Событие не найдено.');
  }

  event.deleteEvent();
  return { id: eventId };
}

function validateEventPayload_(payload, requireId) {
  if (!payload || !payload.title || !payload.start || (!payload.allDay && !payload.end)) {
    throw new Error('Заполните название, дату начала и дату окончания.');
  }

  if (requireId && !payload.id) {
    throw new Error('Не указан идентификатор события.');
  }

  if (!payload.allDay && new Date(payload.start) >= new Date(payload.end)) {
    throw new Error('Окончание должно быть позже начала.');
  }
}

function serializeEvent_(event) {
  return {
    id: event.getId(),
    title: event.getTitle(),
    description: event.getDescription(),
    location: event.getLocation(),
    start: event.getStartTime().toISOString(),
    end: event.getEndTime().toISOString(),
    allDay: event.isAllDayEvent()
  };
}
