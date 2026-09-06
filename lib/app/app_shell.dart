import 'package:flutter/material.dart';
import '../core/theme/evermore_theme.dart';
import '../services/account_service.dart';
import '../screens/home/home_screen.dart';
import '../screens/community/community_screen.dart';
import '../screens/profile/account_profile_screen.dart';
import '../screens/account/registration_screen.dart';
import '../screens/courses/course_catalog_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override State<AppShell> createState() => _AppShellState();
}
class _AppShellState extends State<AppShell> {
  int index = 0; bool registered = false;
  @override void initState(){super.initState(); _load();}
  Future<void> _load() async { final value = await AccountService().isRegistered(); if(mounted)setState(()=>registered=value); }
  Future<void> _activate() async { await Navigator.push(context,MaterialPageRoute(builder:(_)=>const RegistrationScreen())); await _load(); }
  @override Widget build(BuildContext context) {
    final screens = const [HomeScreen(), CourseCatalogScreen(), CommunityScreen(), AccountProfileScreen()];
    return Scaffold(
      body: Stack(children: [screens[index], if(index == 0 && !registered) Positioned(left:20,right:20,bottom:82,child: _ActivationBar(onTap:_activate))]),
      bottomNavigationBar: NavigationBar(
        selectedIndex:index, onDestinationSelected:(i)=>setState(()=>index=i),
        backgroundColor: Colors.white.withValues(alpha:.94), elevation:0,
        indicatorColor: EvermoreTheme.primaryLight,
        destinations: const [
          NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home_rounded),label:'Home'),
          NavigationDestination(icon:Icon(Icons.menu_book_outlined),selectedIcon:Icon(Icons.menu_book_rounded),label:'Learn'),
          NavigationDestination(icon:Icon(Icons.groups_outlined),selectedIcon:Icon(Icons.groups_rounded),label:'Community'),
          NavigationDestination(icon:Icon(Icons.person_outline_rounded),selectedIcon:Icon(Icons.person_rounded),label:'Profile'),
        ],
      ),
    );
  }
}
class _ActivationBar extends StatelessWidget{final VoidCallback onTap;const _ActivationBar({required this.onTap});@override Widget build(BuildContext context)=>Material(color:Colors.transparent,child:InkWell(onTap:onTap,borderRadius:BorderRadius.circular(19),child:Ink(padding:const EdgeInsets.symmetric(horizontal:16,vertical:12),decoration:BoxDecoration(gradient:EvermoreTheme.heroGradient,borderRadius:BorderRadius.circular(19),boxShadow:EvermoreTheme.floatingShadow),child:Row(children:[const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Ready to activate?',style:TextStyle(color:Colors.white,fontWeight:FontWeight.w800,fontSize:13)),SizedBox(height:2),Text('Create your account and continue to payment.',style:TextStyle(color:Colors.white70,fontSize:9.5))])),Container(width:38,height:38,decoration:BoxDecoration(color:Colors.white.withValues(alpha:.15),shape:BoxShape.circle),child:const Icon(Icons.arrow_forward_rounded,color:Colors.white,size:18))]))));}
