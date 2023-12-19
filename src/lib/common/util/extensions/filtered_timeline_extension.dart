///NOTE
///2023.12. 14.
///채팅 교체 예정으로 일단 전체 주석 처리
// import 'package:matrix/matrix.dart';
//
// extension IsStateExtension on Event {
//   bool get isVisibleInGui =>
//       EventTypes.Message == type; // && !redacted;
//       // always filter out edit and reaction relationships
//       // !{RelationshipTypes.edit, RelationshipTypes.reaction}
//       //     .contains(relationshipType) &&
//       // // always filter out m.key.* events
//       // !type.startsWith('m.key.verification.') &&
//       // // event types to hide: redaction and reaction events
//       // // if a reaction has been redacted we also want it to be hidden in the timeline
//       // !{EventTypes.Reaction, EventTypes.Redaction}.contains(type) || EventTypes.Message == type;
//       // // if we enabled to hide all redacted events, don't show those
//       // (!redacted) &&
//       // // if we enabled to hide all unknown events, don't show those
//       // (isEventTypeKnown) &&
//       // // remove state events that we don't want to render
//       // (isState) &&
//       // // hide unimportant state events
//       // (!isState ||
//       //     importantStateEvents.contains(type)) &&
//       // // hide simple join/leave member events in public rooms
//       // (type != EventTypes.RoomMember ||
//       //     room.joinRules != JoinRules.public ||
//       //     content.tryGet<String>('membership') == 'ban' ||
//       //     stateKey != senderId);
//
//   static const Set<String> importantStateEvents = {
//     EventTypes.Encryption,
//     EventTypes.RoomCreate,
//     EventTypes.RoomMember,
//     EventTypes.RoomTombstone,
//     EventTypes.CallInvite,
//   };
//
//   bool get isState => !{
//         EventTypes.Message,
//         EventTypes.Sticker,
//         EventTypes.Encrypted
//       }.contains(type);
// }
