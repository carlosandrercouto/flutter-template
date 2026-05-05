import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/localization/app_localizations_extension.dart';
import 'package:flutter_template/core/ui/constants/app_styles.dart';
import 'package:flutter_template/core/ui/constants/extension_colors_text.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/enums/error_state_type_enum.dart';
import '../../../../../core/helpers/session_helper.dart';
import '../../../../../core/routes/routes_list.dart';
import '../../../domain/entities/entities_export.dart';
import '../../bloc/home_bloc.dart';
import '../widgets/widgets_export.dart';

/// Tela principal da aplicação.
///
/// Demonstra o fluxo completo da feature Home:
/// - Dados do usuário recuperados do [SessionHelper]
/// - Lista de transações gerenciada pelo [HomeBloc]
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;
  final String _userName = GetIt.instance<SessionHelper>().userName;

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _homeBloc.add(const LoadHomeTransactionsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeaderWidget(userName: _userName),
            BlocBuilder<HomeBloc, HomeState>(
              bloc: _homeBloc,
              builder: (context, state) {
                if (state is LoadedHomeTranactionsState) {
                  return BalanceCardWidget(balance: state.homeData.balance);
                }
                return const BalanceCardWidget();
              },
            ),
            const SizedBox(height: 24),
            _buildTransactionListTitle(context),
            const SizedBox(height: 8),
            Expanded(
              child: BlocConsumer<HomeBloc, HomeState>(
                bloc: _homeBloc,
                listenWhen: (_, current) {
                  return [
                    ErrorLoadHomeTransactionsState,
                  ].contains(current.runtimeType);
                },
                listener: (context, state) {
                  if (state is ErrorLoadHomeTransactionsState &&
                      state.errorStateType == ErrorStateType.sessionExpired) {
                    /// TODO: Implementar tratamento para quando a sessão do usuário expirar
                    // Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
                  }
                },
                buildWhen: (previous, current) {
                  return (current is LoadingHomeTransactionsState ||
                      current is LoadedHomeTranactionsState ||
                      current is ErrorLoadHomeTransactionsState);
                },
                builder: (BuildContext context, HomeState currentState) {
                  if (currentState is LoadedHomeTranactionsState) {
                    return _loadedHomeState(
                      currentState.homeData.transactionsList,
                    );
                  } else if (currentState is ErrorLoadHomeTransactionsState) {
                    return _errorHandleLoadTransactionsState(currentState);
                  }

                  return _loadingHomeState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Retorna widget de acordo com o estado retornado pelo Bloc
  // ===================================================================================================================

  Widget _loadingHomeState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF6C63FF),
        strokeWidth: 2.5,
      ),
    );
  }

  Widget _loadedHomeState(List<TransactionEntity> transactions) {
    final textColors = Theme.of(context).extension<TextColors>();
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          context.translate('no_transactions_found'),
          style: AppStyles.regular14().copyWith(
            color: textColors?.general,
          ),
        ),
      );
    }
    return TransactionListWidget(transactions: transactions);
  }

  Widget _errorHandleLoadTransactionsState(
    ErrorLoadHomeTransactionsState state,
  ) {
    return HomeErrorWidget(
      icon: Icons.error_outline_rounded,
      message: context.translate(state.errorStateType.message),
      onTap: () => _homeBloc.add(const LoadHomeTransactionsEvent()),
    );
  }

  // Widgets auxiliares
  // ===================================================================================================================

  Widget _buildTransactionListTitle(BuildContext context) {
    final textColors = Theme.of(context).extension<TextColors>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.translate('latest_transactions'),
            style: AppStyles.bold17().copyWith(
              color: textColors?.general,
              letterSpacing: -0.2,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed(RoutesList.ClientsScreen.routeName);
            },
            child: Text(
              context.translate('view_clients'),
              style: AppStyles.semiBold14().copyWith(
                color: textColors?.withLink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
