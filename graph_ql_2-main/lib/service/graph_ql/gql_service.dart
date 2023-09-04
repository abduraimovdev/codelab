import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

sealed class GQLService {
  /// setting and connecting url
  static String beararKey = "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik9FWTJSVGM1UlVOR05qSXhSRUV5TURJNFFUWXdNekZETWtReU1EQXdSVUV4UVVRM05EazFNQSJ9.eyJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWRlZmF1bHQtcm9sZSI6InVzZXIiLCJ4LWhhc3VyYS1hbGxvd2VkLXJvbGVzIjpbInVzZXIiXSwieC1oYXN1cmEtdXNlci1pZCI6ImF1dGgwfDY0ZWViZWViZjM3MmNlZmMwOWYzMWYzZiJ9LCJuaWNrbmFtZSI6ImNvZGVyODExOCIsIm5hbWUiOiJjb2RlcjgxMThAZ21haWwuY29tIiwicGljdHVyZSI6Imh0dHBzOi8vcy5ncmF2YXRhci5jb20vYXZhdGFyL2ExYjBlMGI1Nzk3Mzk1ZWM3Y2QxNDlmYzAyYjQyZDU1P3M9NDgwJnI9cGcmZD1odHRwcyUzQSUyRiUyRmNkbi5hdXRoMC5jb20lMkZhdmF0YXJzJTJGY28ucG5nIiwidXBkYXRlZF9hdCI6IjIwMjMtMDktMDRUMTQ6NTI6MjguOTY3WiIsImlzcyI6Imh0dHBzOi8vZ3JhcGhxbC10dXRvcmlhbHMuYXV0aDAuY29tLyIsImF1ZCI6IlAzOHFuRm8xbEZBUUpyemt1bi0td0V6cWxqVk5HY1dXIiwiaWF0IjoxNjkzODM5MTUwLCJleHAiOjE2OTM4NzUxNTAsInN1YiI6ImF1dGgwfDY0ZWViZWViZjM3MmNlZmMwOWYzMWYzZiIsImF0X2hhc2giOiJibjEwM3BmSjhRaUFiLURNMWxCbWtRIiwic2lkIjoiN21mWVA2emJIZ0ExeWhuQk9ORjRCOHVSZVR1dmdvRDciLCJub25jZSI6IjFheW16VExWVmF1TUZjVl9LLUdjZFBjUFU1UkouUU8zIn0.lshN0av9EJkrwVMeIPYHTeuZP1c2VM0iFK4-yV0lKK9lMr7pJYO17gJjx8JxDapUTn5itQO_tLo-OmhYiTZyTIn9R0oC4HxxPQArzL22Annofe7SQILaeUKay3WR_2OMu3bmZtGXHGZV0wVttVmxkm9OyB6alX4yJpPIVKV4uKZ7QrrInvjpdRkSwYPyKi99UcuFVNkNcwaQPtbVaJmtbB8uAAtdFKBr1BPAMey4DRs2Q4PAIxYqgaw7WYu4rgs63PCZyxeS4bPNvEkYHNorV9IE2n5uh5VNpTdw4iRf0ajcyG8pMTAVYsSOvnRQgZVK49-oLrUlND1i-UjdOFvKOw";
  static final HttpLink _httpLink = HttpLink('https://hasura.io/learn/graphql');

  static final AuthLink _authLink = AuthLink(
    getToken: () async => beararKey,
  );

  static final _socketLink = WebSocketLink("wss://hasura.io/learn/graphql",
      subProtocol: GraphQLProtocol.graphqlWs,
      config: SocketClientConfig(initialPayload: () async {
    return {
      'headers': {
        "Content-Type": "application/json",
        'Authorization': beararKey,
      },
    };
  }));

  static final Link _linkHttp = _authLink.concat(_socketLink);
  static final Link link = _linkHttp.concat(_httpLink);

  /// controller
  static GraphQLClient get gql =>
      GraphQLClient(cache: GraphQLCache(), link: link);
  static ValueNotifier<GraphQLClient> client = ValueNotifier(gql);
}

sealed class GQLRequest {
  static const queryTodoAll = """
query{
  todos {
    id
    is_completed
    created_at
    is_public
    title
    user_id
  }
}  
  """;

  static const queryTodosSubscription = """
subscription {
  todos(order_by: {created_at: desc}, where: {user_id: {_eq: "auth0|64eeba2764528afaf414bdc9"}}) {
    created_at
    id
    is_completed
    is_public
    title
    user_id
  }
} 
  """;

  static String queryTodoMe(
          [String userId = "auth0|64eeba2764528afaf414bdc9"]) =>
      """
{
  todos(where: {user_id: {_eq: "$userId"}}) {
    created_at
    id
    is_completed
    is_public
    title
    user_id
  }
} 
  """;

  static String mutationEditTodo(int todoId, bool isCompleted) {
    return """
mutation {
  update_todos(where: {id: {_eq: $todoId}}, _set: {is_completed: $isCompleted}) {
    affected_rows
    returning {
      created_at
      id
      is_completed
      is_public
      title
      user_id
    }
  }
}
    """;
  }

  static String mutationCreateTodo(String title, bool isPublic) {
    return """
mutation {
  insert_todos(objects: {is_public: $isPublic, title: "$title"}) {
    affected_rows
    returning {
      created_at
      id
      is_completed
      is_public
      title
      user {
        id
        name
      }
      user_id
    }
  }
}
    """;
  }

  static String mutationDeleteTodo(int todoId) {
    return """
mutation {
  delete_todos(where: {id: {_eq: $todoId}}) {
    affected_rows
    returning {
      created_at
      id
      is_completed
      is_public
      title
      user_id
    }
  }
}
    """;
  }
}
