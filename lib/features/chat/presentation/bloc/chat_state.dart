part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatsLoadedSuccess extends ChatState {
  final List<Chat> chatHeads;

  ChatsLoadedSuccess({
    required this.chatHeads,
  });
}

final class ChatInsertSuccess extends ChatState {
  final Chat chat;

  ChatInsertSuccess({
    required this.chat,
  });
}


final class ChatInsertMembersSuccess extends ChatState {

}

final class ChatDeleteSuccess extends ChatState {
  final int id;

  ChatDeleteSuccess({
    required this.id,
  });
}


final class ChatFailure extends ChatState {
  final String message;

  ChatFailure({
    required this.message,
  });
}
