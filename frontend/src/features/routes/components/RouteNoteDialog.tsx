import { useEffect, useState } from 'react';
import { FileText, Trash2, X } from 'lucide-react';
import { useTranslation } from 'react-i18next';
import type { CourseNote } from '../model/types';

interface RouteNoteDialogProps {
  courseTitle: string;
  note?: CourseNote;
  onClose: () => void;
  onSave: (content: string) => void;
  onDelete: () => void;
}

export function RouteNoteDialog({ courseTitle, note, onClose, onSave, onDelete }: RouteNoteDialogProps) {
  const { i18n, t } = useTranslation();
  const [content, setContent] = useState(note?.content ?? '');
  useEffect(() => {
    const closeOnEscape = (event: KeyboardEvent) => { if (event.key === 'Escape') onClose(); };
    document.addEventListener('keydown', closeOnEscape);
    return () => document.removeEventListener('keydown', closeOnEscape);
  }, [onClose]);
  return <div className="route-dialog-backdrop" role="presentation" onMouseDown={event => { if (event.target === event.currentTarget) onClose(); }}>
    <section className="route-dialog route-note-dialog" role="dialog" aria-modal="true" aria-labelledby="route-note-title">
      <button className="route-dialog__close" type="button" onClick={onClose} aria-label={t('myPath.closeDialog')}><X aria-hidden="true" /></button>
      <h2 id="route-note-title" className="route-note-dialog__course"><FileText size={20} aria-hidden="true" /><span>{courseTitle}</span></h2>
      <div className="route-note-dialog__sticky">
        <textarea value={content} onChange={event => setContent(event.target.value)} aria-label={t('myPath.note')} placeholder={t('myPath.notePlaceholder')} autoFocus />
      </div>
      {note && <p className="route-note-dialog__updated">{t('myPath.noteUpdated', { date: new Intl.DateTimeFormat(i18n.language, { dateStyle: 'medium', timeStyle: 'short' }).format(new Date(note.updatedAt)) })}</p>}
      <footer><button type="button" className="cq-button cq-button--secondary" onClick={onClose}>{t('myPath.cancel')}</button>
        {note && <button type="button" className="route-note-dialog__delete" onClick={() => { onDelete(); onClose(); }}><Trash2 size={16} aria-hidden="true" />{t('myPath.deleteNote')}</button>}
        <button type="button" className="cq-button cq-button--primary" onClick={() => { onSave(content); onClose(); }}>{t('myPath.saveNote')}</button>
      </footer>
    </section>
  </div>;
}
