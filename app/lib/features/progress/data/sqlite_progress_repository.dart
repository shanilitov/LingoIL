import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../application/progress_service.dart';
import '../domain/progress_entities.dart';
import '../domain/srs_scheduler.dart';

class SqliteProgressRepository implements ProgressRepository {
  SqliteProgressRepository(this._db);

  final Database _db;

  @override
  Future<VocabularyProgress?> getProgress(String userId, String vocabId) async {
    final rows = await _db.query(
      'vocabulary_progress',
      where: 'user_id = ? and vocab_id = ?',
      whereArgs: [userId, vocabId],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final row = rows.first;

    return VocabularyProgress(
      userId: row['user_id'] as String,
      vocabId: row['vocab_id'] as String,
      srs: SrsState(
        repetition: row['repetition'] as int,
        intervalDays: row['interval_days'] as int,
        easeFactor: (row['ease_factor'] as num).toDouble(),
        dueAt: DateTime.parse(row['due_at'] as String).toUtc(),
        lastQuality: row['last_quality'] as int?,
        lastReviewedAt: row['last_reviewed_at'] != null ? DateTime.parse(row['last_reviewed_at'] as String).toUtc() : null,
      ),
      lapses: row['lapses'] as int,
      successStreak: row['success_streak'] as int,
      totalReviews: row['total_reviews'] as int,
    );
  }

  @override
  Future<void> upsertProgress(VocabularyProgress progress) async {
    await _db.insert(
      'vocabulary_progress',
      {
        'user_id': progress.userId,
        'vocab_id': progress.vocabId,
        'repetition': progress.srs.repetition,
        'interval_days': progress.srs.intervalDays,
        'ease_factor': progress.srs.easeFactor,
        'due_at': progress.srs.dueAt.toUtc().toIso8601String(),
        'last_quality': progress.srs.lastQuality,
        'last_reviewed_at': progress.srs.lastReviewedAt?.toUtc().toIso8601String(),
        'lapses': progress.lapses,
        'success_streak': progress.successStreak,
        'total_reviews': progress.totalReviews,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> enqueueSyncEvent(SyncQueueEvent event) async {
    await _db.insert('sync_queue', {
      'idempotency_key': event.idempotencyKey,
      'user_id': event.userId,
      'event_type': event.eventType,
      'payload_json': jsonEncode(event.payload),
      'created_at': event.createdAt.toUtc().toIso8601String(),
      'sync_status': 'pending',
      'attempt_count': 0,
    });
  }

  Future<List<SyncQueueEvent>> getPendingEvents({int limit = 100}) async {
    final rows = await _db.query(
      'sync_queue',
      where: 'sync_status = ?',
      whereArgs: ['pending'],
      orderBy: 'created_at asc',
      limit: limit,
    );

    return rows.map((row) {
      return SyncQueueEvent(
        idempotencyKey: row['idempotency_key'] as String,
        userId: row['user_id'] as String,
        eventType: row['event_type'] as String,
        payload: (jsonDecode(row['payload_json'] as String) as Map).cast<String, Object?>(),
        createdAt: DateTime.parse(row['created_at'] as String).toUtc(),
      );
    }).toList(growable: false);
  }

  Future<void> markEventSynced(String idempotencyKey) async {
    await _db.update(
      'sync_queue',
      {
        'sync_status': 'synced',
        'last_error': null,
      },
      where: 'idempotency_key = ?',
      whereArgs: [idempotencyKey],
    );
  }

  Future<void> markEventFailed(String idempotencyKey, String error) async {
    await _db.rawUpdate(
      '''
      update sync_queue
      set sync_status = 'pending',
          attempt_count = attempt_count + 1,
          last_error = ?
      where idempotency_key = ?
      ''',
      [error, idempotencyKey],
    );
  }
}
