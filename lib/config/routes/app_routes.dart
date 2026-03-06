class AppRoutes {
  static const root = '/';
  static const login = '/login';
  static const register = '/register';
  static const boards = '/boards';

  static String boardDetail(String boardId) => '/boards/$boardId';
}
